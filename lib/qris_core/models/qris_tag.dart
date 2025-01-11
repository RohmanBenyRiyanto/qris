/// A class representing a tag in the QRIS MPM (Merchant Payment Method) structure.
/// Each tag has an identifier, a name, and optionally, a list of child tags.
class QrisTag {
  /// The unique identifier for this tag.
  final String id;

  /// The name associated with this tag.
  final String name;

  /// A list of child tags associated with this tag. Defaults to an empty list.
  final List<QrisTag> children;

  String get label => name
      .replaceAll('_', ' ')
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');

  /// Constructor for creating a [QrisTag] instance with the provided [id], [name],
  /// and an optional list of [children]. If no children are provided, the list is empty by default.
  const QrisTag({
    required this.id,
    required this.name,
    this.children = const [],
  });

  /// A factory constructor to create an empty [QrisTag] with an empty [id] and [name].
  /// This can be used when no tag data is available.
  factory QrisTag.empty() {
    return const QrisTag(id: '', name: '');
  }

  /// Finds a child tag by its [childId].
  /// Returns the matching child tag if found; otherwise, returns an empty tag.
  ///
  /// - [childId]: The unique identifier of the child tag to find.
  /// - Returns: The [QrisTag] with the specified [childId], or an empty [QrisTag] if no match is found.
  QrisTag? findChild(String childId) {
    return children.firstWhere(
      (child) => child.id == childId,
      orElse: () => QrisTag.empty(),
    );
  }
}
