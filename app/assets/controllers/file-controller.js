import { Controller } from 'stimulus'

export default class extends Controller {
    download() {
        axios.get(this.path, { responseType: 'stream' })
            .then(function (response) {
                response.data.pipeTo(StreamSaver.createWriteStream(this.name))
            })
            .catch(function (error) {
                if (error.response.status === 401) {
                    this.targets.find('passphrase-modal').modal('toggle')
                } else {
                    this.targets.find('error-modal').modal('toggle')
                }
            })
    }

    decrypt() {
        axios.get(this.path + '/' + this.passphrase, { responseType: 'stream' })
            .then(function (response) {
                response.data.pipeTo(StreamSaver.createWriteStream(this.name))
            })
            .catch(function (error) {
                this.targets.find('error-modal').modal('toggle')
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