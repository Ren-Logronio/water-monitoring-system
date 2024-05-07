// select interaction
import { Select } from 'ol/interaction';
import { click } from 'ol/events/condition';
import VectorLayer from 'ol/layer/Vector';

// style for selected/unselected feature
import { styleSelected, styleNormal } from './vectorStyle';
import Feature from 'ol/Feature';


// select interaction, needs the vector layer as parameter
// to ensure that each map instance has its own select interaction
export const selectInteraction = (handleFeatureSelection: (feature: Feature<any> | null) => void) => {
    
    // holds the selected feature
    let selectedFeature: Feature<any> | null = null;

    function newSelect(vectorLayer: VectorLayer<any>) {
        // create the select interaction
        const select = new Select({
            condition: click,
            layers: [vectorLayer],
        });

        // on select change set the style of the selected feature
        select.on('select', (e) => {
            // when a feature is selected
            e.selected.forEach((feature) => {
                feature.setStyle(styleSelected);
                selectedFeature = feature;
                
                // handle the selected feature
                handleFeatureSelection(selectedFeature);
            });

            // when a feature is deselected
            e.deselected.forEach((feature) => {
                feature.setStyle(styleNormal);
                selectedFeature = null;
            });

        });
        

        return select;
        }

    function getSelectedFeature() {
        return selectedFeature;
    }

    // return the methods
    return {
        newSelect: newSelect,
        selectedFeature: getSelectedFeature,
    }
}