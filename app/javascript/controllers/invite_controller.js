import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['url'];

  copy() {
    this.urlTarget.select();
    this.urlTarget.setSelectionRange(0, 99999);

    document.execCommand("copy");

    alert("Link copied to clipboard!");
  }
}