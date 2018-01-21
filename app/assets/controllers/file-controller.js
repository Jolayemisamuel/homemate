import { Controller } from 'stimulus'

export default class extends Controller {
    download(event) {
        event.preventDefault()
        const parent = this

        axios.get(parent.path, { responseType: 'blob' })
            .then(function (response) {
                if (response.data.type === 'application/pdf') {
                    window.open(encodeURI('/documents/viewer?file=/' + parent.path), '_blank', 'location=0,menubar=0,toolbar=0')
                } else {
                    filesaver.saveAs(response.data, parent.name)
                }
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

        axios.get(parent.path + '/' + parent.passphrase, { responseType: 'blob' })
            .then(function (response) {
                if (response.data.type === 'application/pdf') {
                    window.open(encodeURI('/documents/viewer?file=' + parent.path + '/' + parent.passphrase), '_blank',
                        'location=0,menubar=0,toolbar=0')
                } else {
                    filesaver.saveAs(response.data, parent.name)
                }
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