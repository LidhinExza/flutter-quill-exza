import 'package:flutter_quill/flutter_quill.dart' as quill;

class RewiseResourceBlockEmbed extends quill.BlockEmbed {
  RewiseResourceBlockEmbed(super.type, super.data);
  static const String rewiseResourceEmbedType = 'rewise_resource_embed';

  static RewiseResourceBlockEmbed fromJsonString(String resourceJsonString) {
    return RewiseResourceBlockEmbed(
        rewiseResourceEmbedType, resourceJsonString);
  }
}

class RewiseTexBlockEmbed extends quill.BlockEmbed {
  RewiseTexBlockEmbed(super.type, super.data);
  static const String rewiseTexEmbedType = 'rewise_tex_embed';

  static RewiseTexBlockEmbed fromString(String texString) {
    return RewiseTexBlockEmbed(rewiseTexEmbedType, texString);
  }
}
