import { ModalContext } from "@/providers/ModalProvider";
import { useContext } from "react";

export default function useAddFarmModal() {
    return useContext(ModalContext).addFarmModal;
}