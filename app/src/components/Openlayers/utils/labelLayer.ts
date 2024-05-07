import VectorLayer from "ol/layer/Vector";
import VectorSource from "ol/source/Vector";
import Feature from "ol/Feature";
import { Polygon } from "ol/geom";

import { styleText } from "./vectorStyle";
import { vector_data } from "./vectorData";
import { usePondGeometryStore } from "@/store/pondGeometryStore";
import { useVectorSourceStore } from "@/store/vectorSourceStore";
import { useVectorLayerStore } from "@/store/vectorLayerStore";


// returns the label vector layer
export const labelLayer = () => {
    // create the label vector source
    const labelVectorSource = new VectorSource();
    // set the label vector source to the store
    const setLabelVectorSource = useVectorSourceStore.getState().setLabelVectorSource;
    setLabelVectorSource(labelVectorSource);

    const vectorLayer = new VectorLayer({
        source: labelVectorSource,
        visible: true,
    });
    // set the label vector layer to the store
    // const setLabelVectorLayer = useVectorLayerStore.getState().setLabelVectorLayer;
    // setLabelVectorLayer(vectorLayer);


    // create the label features from the vector data
    vector_data.forEach((data) => {
        let coordinates = data.coordinates.map(coord => [ coord.longitude, coord.latitude]);
        let geometry = new Polygon([coordinates]);

        // create the label feature
        const labelFeature = new Feature({
            geometry: geometry,
            name: data.name ? data.name : "",
        });

        // set the id of the label feature
        labelFeature.setId(data.id as number);

        // set the style of the label feature
        labelFeature.setStyle(styleText(data.name));

        // add the label feature to the label vector source
        labelVectorSource.addFeature(labelFeature);
    });

    // return the label vector layer
    return vectorLayer;
}