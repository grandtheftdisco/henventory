import { Controller } from "@hotwired/stimulus"

// Floating scroll-down arrow on the mobile dashboard. Two jobs:
//
//   1. Fade out when the last section is in view (it's no longer useful).
//   2. On tap, scroll the *next* dashboard section into view.
//
// To know which section is "next," we observe all .dashboard-section
// elements and track the one with the largest visible ratio. That's the
// section the user is currently looking at; the next sibling section is
// where a tap should take them.
//
// IntersectionObserver fires when the visible ratio crosses any of the
// thresholds in `threshold:`; we use a few stops so the "current section"
// updates smoothly as the user scrolls between snap stops.
export default class extends Controller {
  static values = {
    fadeAt: { type: Number, default: 0.4 },
  }

  connect() {
    this.sections = Array.from(document.querySelectorAll(".dashboard-section"))
    if (this.sections.length === 0) return

    this.ratios = new WeakMap()
    this.observer = new IntersectionObserver(
      (entries) => this.#onIntersect(entries),
      { threshold: [0, 0.25, 0.5, 0.75, 1] }
    )
    this.sections.forEach((s) => this.observer.observe(s))

    // Wire interactivity. CSS owns cursor/pointer-events; we only handle
    // event listeners + a11y attributes the bare div can't carry on its
    // own. (We remove aria-hidden because once it's tappable, screen
    // readers should announce it.)
    this.element.addEventListener("click", this.scrollNext)
    this.element.addEventListener("keydown", this.#onKeydown)
    this.element.setAttribute("role", "button")
    this.element.setAttribute("aria-label", "Scroll to next section")
    this.element.removeAttribute("aria-hidden")
    this.element.tabIndex = 0
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
    this.element.removeEventListener("click", this.scrollNext)
    this.element.removeEventListener("keydown", this.#onKeydown)
  }

  scrollNext = (event) => {
    if (event) event.preventDefault()
    const current = this.#mostVisibleSection()
    if (!current) return
    const idx = this.sections.indexOf(current)
    const next = this.sections[idx + 1] || this.sections[this.sections.length - 1]
    next.scrollIntoView({ behavior: "smooth", block: "start" })
  }

  #onIntersect(entries) {
    entries.forEach((e) => this.ratios.set(e.target, e.intersectionRatio))

    // Hide the arrow when the last section is sufficiently in view.
    const last = this.sections[this.sections.length - 1]
    const lastRatio = this.ratios.get(last) || 0
    this.element.dataset.visible = lastRatio >= this.fadeAtValue ? "false" : "true"
  }

  #mostVisibleSection() {
    let best = null
    let bestRatio = -1
    this.sections.forEach((s) => {
      const r = this.ratios.get(s) || 0
      if (r > bestRatio) {
        bestRatio = r
        best = s
      }
    })
    return best
  }

  #onKeydown = (event) => {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault()
      this.scrollNext(event)
    }
  }
}
