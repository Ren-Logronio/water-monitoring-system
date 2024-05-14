// this funciton will retrive the coordinates of the points from the database
// and adds them to the vector source of the point layer

import { useVectorSourceStore } from "@/store/vectorSourceStore"
import Feature from "ol/Feature";
import { Point } from "ol/geom";
import { pinStyle } from "./styles/pinStyle";

export const addPoints = (coordinate: any, name: string, id: string | number) => {
    // get the point vector source
    const pointVectorSource = useVectorSourceStore.getState().pointVectorSource;

    // check if the point vector source is initialized
    if (!pointVectorSource) return;

    // create the point feature
    let geometry = new Point([coordinate[0], coordinate[1]]); // longitude, latitude
    const feature = new Feature({
        geometry: geometry,
        extent: geometry.getExtent(),
        name: name,
        visible: true,
    });

    // set the id of the feature
    feature.setId(id);

    // set the style of the feature
    feature.setStyle(pinStyle(name));

    // add the feature to the vector source
    pointVectorSource.addFeature(feature);
    return id;
}

