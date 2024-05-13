import { useVectorSourceStore } from "@/store/vectorSourceStore";

export const removePoints = (id: number | string) => {
    console.log("removing point with id: ", id);

    // get the point vector source
    const pointVectorSource = useVectorSourceStore.getState().pointVectorSource;

    // check if the point vector source is initialized
    if (!pointVectorSource) return;

    // get the feature with the id
    const feature = pointVectorSource.getFeatureById(id);

    console.log("feature: ", feature);

    // remove the feature from the vector source
    feature && pointVectorSource.removeFeature(feature);
}