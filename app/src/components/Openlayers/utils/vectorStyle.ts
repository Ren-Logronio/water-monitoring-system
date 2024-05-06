//used for styling the vectors
import Fill from "ol/style/Fill";
import Stroke from "ol/style/Stroke";
import Style from "ol/style/Style";


// style for all features
export const styleNormal = new Style({
    fill: new Fill({
        color: "rgba(255, 255, 255, 0.2)",
    }),
    stroke: new Stroke({
        color: "white",
        width: 2,
    }),

});

// style for selected feature
export const styleSelected = new Style({
    fill: new Fill({
        color: "rgba(255, 255, 255, 0.5)",
    }),
    stroke: new Stroke({
        color: "#ffcc33",
        width: 3,
    }),
});