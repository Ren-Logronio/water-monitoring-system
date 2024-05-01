export function pathIsSignIn(path: string) {
    return ["/signin", "signin?signout", "/"].includes(path);
}

export function pathIsSignUp(path: string) {
    return ["/signup", "/"].includes(path);
}