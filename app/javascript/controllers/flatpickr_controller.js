import Flatpickr from "stimulus-flatpickr"

export default class extends Flatpickr {
  connect() {
    console.log("Flatpickr controller connected")
    super.connect()
  }

  disconnect() {
    console.log("Flatpickr controller disconnected")
    super.disconnect()
  }
}
