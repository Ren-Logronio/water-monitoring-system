import Feature from "ol/Feature";
import { create } from "zustand";


interface PondGeometryStore {
    ponds: Feature[];
    storePonds: (ponds: Feature[]) => void;
}


export const usePondGeometryStore = create<PondGeometryStore>((set) => ({
    ponds: [],

    // store the ponds
    storePonds: (ponds: Feature[]) => { 
        set((state) => {
            return {
                ponds: [...state.ponds, ...ponds], 
            };
        });
    },
}));