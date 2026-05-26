import { Controller } from "@hotwired/stimulus"

// Generic accordion. Each item is a <details data-accordion-target="item">.
// Multiple items can be open at once — this controller exists only to add
// keyboard niceties + a stable hook for designs that want richer behavior
// later (e.g. anchor-link auto-open on the FAQ).
//
// Usage:
//   <div data-controller="accordion">
//     <details data-accordion-target="item" id="q-flock-vs-layer">
//       <summary>...</summary>
//       <div>...</div>
//     </details>
//   </div>
export default class extends Controller {
  static targets = ["item"]

  connect() {
    if (window.location.hash) this.#openMatchingHash(window.location.hash.slice(1))
    this.hashHandler = () => this.#openMatchingHash(window.location.hash.slice(1))
    window.addEventListener("hashchange", this.hashHandler)
  }

  disconnect() {
    window.removeEventListener("hashchange", this.hashHandler)
  }

  #openMatchingHash(id) {
    if (!id) return
    const match = this.itemTargets.find((el) => el.id === id)
    if (match) {
      match.open = true
      match.scrollIntoView({ behavior: "smooth", block: "start" })
    }
  }
}
