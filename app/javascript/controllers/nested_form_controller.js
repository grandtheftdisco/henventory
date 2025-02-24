import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "formTemplate", "itemsList" ]
  static values = {
    patternToReplaceWithIndex: String
  }

  addItem(e) {
    e.preventDefault(); e.stopPropagation();

    this.itemsListTarget.insertAdjacentHTML('beforeend', this.generateFormHTML())
  }

  generateFormHTML() {
    const html = this.formTemplateTarget.innerHTML.toString()

    return html.replaceAll(this.patternToReplaceWithIndexValue, new Date().getTime())
  }
}