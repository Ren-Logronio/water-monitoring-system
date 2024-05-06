// select interaction
import { Select } from 'ol/interaction';
import { click } from 'ol/events/condition';
import { vectorLayer } from './vectorSource';

// style for selected/unselected feature
import { styleSelected } from './vectorStyle';
import { styleNormal } from './vectorStyle';


export const selectInteraction = () => {

    // create the select interaction
    const select = new Select({
        condition: click,
        layers: [vectorLayer],
    });

    // on select change set the style of the selected feature
    select.on('select', (e) => {
        // set the style of the selected feature
        e.selected.forEach((feature) => {
            feature.setStyle(styleSelected);
        });

        // set the style of the unselected feature
        e.deselected.forEach((feature) => {
            feature.setStyle(styleNormal);
        });
    });

    return select;
}