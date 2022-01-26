let definitions = [
  (MinecraftItem_Texture_minecraft_1_7_10.data, 16),
  (MinecraftItem_Texture_minecraft_1_13_2.data, 16),
  (MinecraftItem_Texture_minecraft_1_18_1.data, 16),
]

type textureVersion = {
  textureDef: Generator.textureDef,
  frames: array<Generator_TextureFrame.frame>,
}

type selectedTextureFrame = {
  textureDefId: string,
  frame: Generator_TextureFrame.frame,
}

external asJson: 'a => Js.Json.t = "%identity"
external aSelectedTextureFrames: Js.Json.t => array<selectedTextureFrame> = "%identity"

let encodeSelectedTextureFrames = (selectedTextureFrames: array<selectedTextureFrame>) => {
  selectedTextureFrames->asJson->Js.Json.serializeExn
}

let decodeSelectedTextureFrames = (json: string) => {
  if Js.String2.length(json) > 0 {
    json->Js.Json.parseExn->aSelectedTextureFrames
  } else {
    []
  }
}

let textureVersions: array<textureVersion> = Belt.Array.map(definitions, definition => {
  let (data, frameSize) = definition
  let (textureDef, tiles) = data
  let frames = tiles->Generator_TextureFrame.tilesToFrames(frameSize)
  {textureDef: textureDef, frames: frames}
})

let allTextureDefs = Belt.Array.map(textureVersions, ({textureDef}) => textureDef)

let versionIds =
  Belt.Array.map(textureVersions, ({textureDef}) => textureDef.id)->Belt.Array.reverse

let findVersion = versionId => {
  Belt.Array.getBy(textureVersions, ({textureDef}) => textureDef.id === versionId)
}
