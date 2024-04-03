import VATextureKitMacro

func setNeedsLayout() {
    print("The function was called by the macro")
}

@Layout var someVar = false
@DistinctLayout var someDistinctVar = false

someVar = true
someDistinctVar = true

@DecodableDefaultCase
enum SomeEnum: String, Codable {
    case undefined
    case first
}
