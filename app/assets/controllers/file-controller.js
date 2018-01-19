import { Controller } from 'stimulus'

export default class extends Controller {
    download(event) {
        event.preventDefault()
        const parent = this

        axios.get(parent.path, { responseType: 'blob' })
            .then(function (response) {
                filesaver.saveAs(response.data, parent.name)
            })
            .catch(function (error) {
                if (error.response.status === 401) {
                    const modal = parent.targets.find('passphrase-modal')
                    $(modal).modal('show')
                } else {
                    const modal = parent.targets.find('error-modal')
                    $(modal).modal('show')
                }
            })
    }

    decrypt(event) {
        const parent = this

        event.preventDefault()
        const modal = parent.targets.find('passphrase-modal')
        $(modal).modal('hide')

        axios.get(parent.path + '/' + this.passphrase, { responseType: 'blob' })
            .then(function (response) {
                filesaver.saveAs(response.data, parent.name)
            })
            .catch(function (error) {
                const modal = parent.targets.find('error-modal')
                $(modal).modal('show')
            })
    }

    get name() {
        return this.data.get('name')
    }

    get encrypted() {
        return this.data.get('encrypted')
    }

    get path() {
        return this.data.get('path')
    }

    get passphrase() {
        return this.targets.find('passphrase').value
    }
}