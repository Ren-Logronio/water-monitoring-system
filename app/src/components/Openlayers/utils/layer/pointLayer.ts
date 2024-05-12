import VectorSource from "ol/source/Vector";
import { useVectorSourceStore } from "@/store/vectorSourceStore";
import VectorLayer from "ol/layer/Vector";


// returns the point vector layer
export const pointLayer = () => {

    // create the vector source
    const pointVectorSource = new VectorSource();

    // set the point vector source to the store
    const setPointVectorSource = useVectorSourceStore.getState().setPointVectorSource;
    setPointVectorSource(pointVectorSource);

    // create a vector layer
    const vectorLayer = new VectorLayer({
        source: pointVectorSource,
        visible: true,
    });

    // return the vector layer
    return vectorLayer;
};