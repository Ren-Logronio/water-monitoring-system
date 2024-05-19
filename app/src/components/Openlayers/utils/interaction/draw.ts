import { Draw } from "ol/interaction";
import VectorSource from "ol/source/Vector";


export const draw = (vectorSource: VectorSource) => {

    const draw = new Draw({
        source: vectorSource,
        type: "Point",
    });

    return draw;
}