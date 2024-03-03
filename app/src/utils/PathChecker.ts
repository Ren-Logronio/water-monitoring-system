export function pathIsSignIn(path: string) {
    return ["/signin", "signin?signout", "/"].includes(path);
}