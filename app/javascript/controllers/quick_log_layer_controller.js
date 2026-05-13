import { Controller } from "@hotwired/stimulus"

// Owns Quick-Log state on the Layer-mode dashboard:
//   - which hen is selected
//   - revealing the "Other" expansion pills
//   - showing the +note textarea
//   - submitting with a chosen egg count via the form's Turbo Stream POST
//
// The submit flow goes through the standard form (Turbo handles the
// MIME/Accept negotiation); CollectionEntriesController#create returns a
// Turbo Stream that re-renders the quick-log frames + Today tile +
// today's collections strip.
export default class extends Controller {
  static targets = [
    "form",
    "pillRow",
    "actions",
    "oneButton",
    "twoButton",
    "noteToggle",
    "noteWrap",
    "otherButton",
    "chickenIdField",
    "eggCountField",
    "hint",
  ]

  selectChicken(event) {
    const pill = event.currentTarget
    const chickenId = pill.dataset.chickenId

    // Clear other selections, mark this one.
    this.pillRowTarget.querySelectorAll(".quick-log-pill").forEach((p) => {
      p.classList.toggle("is-selected", p === pill)
      p.setAttribute("aria-checked", p === pill ? "true" : "false")
    })

    this.chickenIdFieldTarget.value = chickenId

    if (this.hasHintTarget) {
      this.hintTarget.textContent = `${pill.dataset.chickenName} — pick eggs`
    }
    this.#setActionsEnabled(true)
  }

  expandOther(event) {
    event.preventDefault()
    this.pillRowTarget
      .querySelectorAll(".quick-log-pill[hidden]")
      .forEach((p) => p.removeAttribute("hidden"))
    if (this.hasOtherButtonTarget) {
      this.otherButtonTarget.remove()
    }
  }

  toggleNote(event) {
    event.preventDefault()
    if (!this.hasNoteWrapTarget) return
    const showing = !this.noteWrapTarget.hasAttribute("hidden")
    if (showing) {
      this.noteWrapTarget.setAttribute("hidden", "")
    } else {
      this.noteWrapTarget.removeAttribute("hidden")
      const ta = this.noteWrapTarget.querySelector("textarea")
      if (ta) ta.focus()
    }
  }

  submitWithCount(event) {
    event.preventDefault()
    const button = event.currentTarget
    const count = parseInt(button.dataset.eggCount, 10) || 1
    if (!this.chickenIdFieldTarget.value) return // no hen selected; ignore

    this.eggCountFieldTarget.value = count
    this.formTarget.requestSubmit()
  }

  #setActionsEnabled(enabled) {
    ;[this.oneButtonTarget, this.twoButtonTarget, this.noteToggleTarget].forEach(
      (b) => {
        if (!b) return
        if (enabled) {
          b.removeAttribute("disabled")
        } else {
          b.setAttribute("disabled", "")
        }
      }
    )
  }
}
