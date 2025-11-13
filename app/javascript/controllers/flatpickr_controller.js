import Flatpickr from "stimulus-flatpickr"

export default class extends Flatpickr {
  connect() {
    console.log("Flatpickr controller connected!")
    console.log("Element:", this.element)
    console.log("Data attributes:", this.element.dataset)
    super.connect()
    console.log("Flatpickr initialized")
    console.log("Flatpickr instance (this.fp):", this.fp)
    console.log("Config:", this.config)

    // Try to manually open it for debugging
    if (this.fp) {
      console.log("FP methods available:", Object.keys(this.fp))
      console.log("Calendar container:", this.fp.calendarContainer)
      console.log("Is calendar in DOM?", document.body.contains(this.fp.calendarContainer))
      console.log("isMobile:", this.fp.isMobile)

      // Try to force open for testing
      setTimeout(() => {
        console.log("Attempting to force open calendar...")
        this.fp.open()

        // Check CSS
        const container = this.fp.calendarContainer
        const styles = window.getComputedStyle(container)
        console.log("Calendar display:", styles.display)
        console.log("Calendar visibility:", styles.visibility)
        console.log("Calendar opacity:", styles.opacity)
        console.log("Calendar position:", styles.position)
        console.log("Calendar top:", styles.top)
        console.log("Calendar left:", styles.left)
        console.log("Has 'open' class?", container.classList.contains('open'))
      }, 1000)
    } else {
      console.error("ERROR: Flatpickr instance (this.fp) is undefined!")
    }
  }

  disconnect() {
    console.log("Flatpickr controller disconnected")
    super.disconnect()
  }
}
