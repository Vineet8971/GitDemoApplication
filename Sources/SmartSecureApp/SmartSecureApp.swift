@main
public struct SmartSecureApp {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(SmartSecureApp().text)
    }
}
