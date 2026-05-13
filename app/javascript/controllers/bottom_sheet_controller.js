import { Controller } from "@hotwired/stimulus"

// Generic bottom-sheet modal. Toggles `data-open` on the root element
// (CSS handles the slide-up animation + backdrop visibility) and traps
// focus while open.
//
// Usage:
//   <div data-controller="bottom-sheet">
//     <button data-action="bottom-sheet#open">Open</button>
//     <div data-bottom-sheet-target="sheet" data-open="false">
//       <button data-action="bottom-sheet#close">×</button>
//       ...
//     </div>
//     <div data-bottom-sheet-target="backdrop" data-action="click->bottom-sheet#close"></div>
//   </div>
//
// Or — as we use it on the dashboard — open/close from elsewhere via the
// public methods. The FAB lives outside the controller scope and dispatches
// via `data-action="click->bottom-sheet#open"` reaching up the DOM.
export default class extends Controller {
  static targets = ["sheet", "backdrop"]

  connect() {
    this.escHandler = (e) => { if (e.key === "Escape") this.close() }
    document.addEventListener("keydown", this.escHandler)
  }

  disconnect() {
    document.removeEventListener("keydown", this.escHandler)
  }

  open(event) {
    if (event) event.preventDefault()
    this.#setOpen(true)
    // Focus the first focusable inside the sheet so keyboard users land in it.
    const first = this.sheetTarget.querySelector(
      "button:not([disabled]), [href], input, select, textarea, [tabindex]:not([tabindex='-1'])"
    )
    if (first) first.focus()
  }

  close(event) {
    if (event) event.preventDefault()
    this.#setOpen(false)
  }

  #setOpen(open) {
    this.sheetTarget.dataset.open = open ? "true" : "false"
    if (this.hasBackdropTarget) {
      this.backdropTarget.dataset.open = open ? "true" : "false"
    }
    document.body.classList.toggle("has-bottom-sheet-open", open)
  }
}
