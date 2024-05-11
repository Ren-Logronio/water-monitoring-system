import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import Feature from "ol/Feature";
import Polygon from "ol/geom/Polygon";

import { vector_data } from "./vectorData";
import { styleNormal } from "./vectorStyle";
import { usePondGeometryStore } from "@/store/pondGeometryStore";
import { useVectorSourceStore } from "@/store/vectorSourceStore";
import { useVectorLayerStore } from "@/store/vectorLayerStore";


// returns the polygon vector layer
export const polygonLayer = () => {
    // create the vector source
    const polygonVectorSource = new VectorSource();
    // set the polygon vector source to the store
    const setPolygonVectorSource = useVectorSourceStore.getState().setPolygonVectorSource;
    setPolygonVectorSource(polygonVectorSource);
    

    // create the vector layer
    const vectorLayer = new VectorLayer({
        source: polygonVectorSource,
        visible: true,
    });
    // set the polygon vector layer to the store
    // const setPolygonVectorLayer = useVectorLayerStore.getState().setPolygonVectorLayer;
    // setPolygonVectorLayer(vectorLayer);


    // add the features to the vector source
    vector_data.forEach((data) => {
        // create the geometry
        let coordinates = data.coordinates.map(coord => [ coord.longitude, coord.latitude]);
        let geometry = new Polygon([coordinates]);
        const feature = new Feature({
            geometry: geometry,
            extent: geometry.getExtent(),
            label: data.name ? data.name : "",
            visible: true,
        });

        // set the id of the feature
        feature.setId(data.id as number);

        // set the style of the feature
        feature.setStyle(styleNormal);

        // add the feature to the vector source
        polygonVectorSource.addFeature(feature);

        // add the feature to the pond geometry store
        usePondGeometryStore.getState().storePonds([feature]);
    });

    // return the vector layer
    return vectorLayer;
}




