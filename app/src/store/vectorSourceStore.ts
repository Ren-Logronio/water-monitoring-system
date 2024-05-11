
import VectorSource from "ol/source/Vector";
import { create } from "zustand";

interface vectorSourceStore {
    polygonVectorSource: VectorSource | null;
    labelVectorSource: VectorSource | null;

    setPolygonVectorSource: (polygonVectorSource: VectorSource) => void;
    setLabelVectorSource: (labelVectorSource: VectorSource) => void;
}

export const useVectorSourceStore = create<vectorSourceStore>((set) => ({
    polygonVectorSource: null,
    labelVectorSource: null,

    setPolygonVectorSource: (polygonVectorSource: VectorSource) => set({ polygonVectorSource }),
    setLabelVectorSource: (labelVectorSource: VectorSource) => set({ labelVectorSource }),
}));