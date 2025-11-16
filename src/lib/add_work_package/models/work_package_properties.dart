class WPLink {
  final String? href;
  final String? title;

  const WPLink({this.href, this.title});

  factory WPLink.fromJson(Map<String, dynamic> json) => WPLink(
        href: json['href'],
        title: json['title'],
      );

  Map<String, dynamic> toJson() => {
        'href': href,
        'title': title,
      };
}

class WPDescription {
  final String format;
  final String raw;
  final String html;

  const WPDescription({
    required this.format,
    required this.raw,
    required this.html,
  });

  factory WPDescription.fromJson(Map<String, dynamic> json) => WPDescription(
        format: json['format'],
        raw: json['raw'],
        html: json['html'],
      );

  Map<String, dynamic> toJson() => {
        'format': format,
        'raw': raw,
      };
}

class WPType {
  final int id;
  final String name;
  final String colorHex;
  final int position;
  final bool isDefault;
  final bool isMilestone;
  final WPLink link;

  const WPType({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.position,
    required this.isDefault,
    required this.isMilestone,
    required this.link,
  });

  factory WPType.fromJson(Map<String, dynamic> json) => WPType(
        id: json['id'],
        name: json['name'],
        colorHex: json['color'],
        position: json['position'],
        isDefault: json['isDefault'],
        isMilestone: json['isMilestone'],
        link: WPLink.fromJson(json['_links']['self']),
      );

  /// Used for sending in API requests body
  Map<String, dynamic> toFullJson() {
    return {
      '_links': {
        'type': link.toJson(),
      }
    };
  }
}

class WPStatus {
  final int id;
  final String name;
  final bool isClosed;
  final bool isDefault;
  final bool isReadonly;
  final int position;
  final String colorHex;
  final WPLink link;

  const WPStatus({
    required this.id,
    required this.name,
    required this.isClosed,
    required this.isDefault,
    required this.isReadonly,
    required this.position,
    required this.colorHex,
    required this.link,
  });

  factory WPStatus.fromJson(Map<String, dynamic> json) => WPStatus(
        id: json['id'],
        name: json['name'],
        isClosed: json['isClosed'],
        isDefault: json['isDefault'],
        isReadonly: json['isReadonly'],
        position: json['position'],
        colorHex: json['color'],
        link: WPLink.fromJson(json['_links']['self']),
      );
}

class WPPriority {
  final int id;
  final String name;
  final int position;
  final bool isDefault;
  final bool isActive;
  final String color;
  final WPLink link;

  const WPPriority({
    required this.id,
    required this.name,
    required this.position,
    required this.isDefault,
    required this.isActive,
    required this.color,
    required this.link,
  });

  factory WPPriority.fromJson(Map<String, dynamic> json) => WPPriority(
        id: json['id'],
        name: json['name'],
        position: json['position'],
        isDefault: json['isDefault'],
        isActive: json['isActive'],
        color: json['color'],
        link: WPLink.fromJson(json['_links']['self']),
      );
}

class WPVersion {
  final int id;
  final String name;
  final WPLink link;

  const WPVersion({
    required this.id,
    required this.name,
    required this.link,
  });

  factory WPVersion.fromJson(Map<String, dynamic> json) => WPVersion(
        id: json['id'],
        name: json['name'],
        link: WPLink.fromJson(json['_links']['self']),
      );
}

class WPCategory {
  final int id;
  final String name;
  final WPLink link;

  const WPCategory({
    required this.id,
    required this.name,
    required this.link,
  });

  factory WPCategory.fromJson(Map<String, dynamic> json) {
    return WPCategory(
      id: json['id'],
      name: json['name'],
      link: WPLink.fromJson(json['_links']['self']),
    );
  }
}

enum ProjectMemberType { assignee, responsible }

class WPUser {
  final int id;
  final String name;
  final WPLink link;

  const WPUser({
    required this.id,
    required this.name,
    required this.link,
  });

  factory WPUser.fromJson(Map<String, dynamic> json) => WPUser(
        id: json['id'],
        name: json['name'],
        link: WPLink.fromJson(json['_links']['self']),
      );
}
