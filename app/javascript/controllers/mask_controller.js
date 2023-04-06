import { Controller } from "stimulus"
import Inputmask from "inputmask"

export default class extends Controller {
  static targets = ['cpf']

  connect() {
    this.cpf(this.cpfTargets)
  }

  cpf(element) {
    Inputmask({
      mask: '999.999.999-99',
      clearIncomplete: true,
      placeholder: " ",
    }).mask(element)
  }
}
