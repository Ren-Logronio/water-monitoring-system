import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import Feature from "ol/Feature";
import Polygon from "ol/geom/Polygon";

import { vector_data } from "./vectorData";
import { styleNormal } from "./vectorStyle";
import { usePondGeometryStore } from "@/store/pondGeometryStore";



// create the vector source
const vectorSource = new VectorSource();

// create the vector layer
export const vectorLayer = new VectorLayer({
    source: vectorSource,
    visible: true,
});

// add the features to the vector source
vector_data.forEach((data) => {
    // create the geometry
    let coordinates = data.coordinates.map(coord => [ coord.longitude, coord.latitude]);
    let geometry = new Polygon([coordinates]);
    const feature = new Feature({
        geometry: geometry,
        extent: geometry.getExtent(),
        visible: true,
    });

    // set the id of the feature
    feature.setId(data.id as number);

    // set the style of the feature
    feature.setStyle(styleNormal);

    // add the feature to the vector source
    vectorSource.addFeature(feature);

    // add the feature to the pond geometry store
    usePondGeometryStore.getState().storePonds([feature]);
});





