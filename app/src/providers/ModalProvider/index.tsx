import { createContext, useState } from "react";

export type ModalType = {
    open: () => void;
    close: () => void;
};

export type AlertModalOptions = {
    cancel?: boolean;
    confirmLabel?: string;
    cancelLabel?: string;
};

export interface AlertModalProps {
    message: string;
    callback: () => void;
    options?: AlertModalOptions;
};

export type ModalContextType = {
    addFarmModal: ModalType;
    // alertModal: ModalType;
};

export const ModalContext = createContext({
    addFarmModal: {
        open: () => { },
        close: () => { }
    },
    // alertModal: {
    //     open: () => { },
    //     close: () => { }
    // }
});

export default function ModalProvider({ children }: { children: React.ReactNode }) {
    const [addFarmModalIsOpen, setAddFarmModalIsOpen] = useState(false);
    const [alertModalIsOpen, setAlertModalIsOpen] = useState(false);

    const addFarmModal = {
        open: () => setAddFarmModalIsOpen(true),
        close: () => setAddFarmModalIsOpen(false),
    };

    const alertModal = {
        open: () => setAlertModalIsOpen(true),
        close: () => setAlertModalIsOpen(false)
    };

    return <ModalContext.Provider value={{ addFarmModal }}>
        {children}
    </ModalContext.Provider>
}


// const addFarmModal = useAddFarmModal()  -->  return const { addFarmModal } = useContext(ModalContext);
// addFarmModal.open();
// addFarmModal.close();

// const editPond = useEditPondModal()  -->  return const { editPond } = useContext(ModalContext);
// editPond.open(pond);
// editPond.close();

// const options = { cancel: true, confirmLabel: "Yes", cancelLabel: "No" }
// const confirmationModal = useAlertModal(message, callback, options); -->  return const { alertModal } = useContext(ModalContext);