import { Controller } from "stimulus";

export default class extends Controller {
    static targets = [ "innerProgressBar"]
    static values = { max: Number, current: Number }

    startRefreshing() {
        setInterval(() => {
            this.refresh();

        }, 100);
    };

    initialize() {
        this.startTime = Date.now();
        this.startRefreshing();
    }

    refresh() {
        var diff = Date.now() - this.startTime
        var next = diff  + this.currentValue

        var scale = next / this.maxValue * 100
         if (scale < 100) {
       
        this.innerProgressBarTarget.style.width = `${scale}%`;
         } else {
             location.reload()
        }
        
        
    }
}
