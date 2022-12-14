import 'package:objectbox/objectbox.dart';

// After update the file run this command -> flutter pub run build_runner build --delete-conflicting-outputs

@Entity()
class BookmarkArticlesEntity {
  // Each "Entity" needs a unique integer ID property.
  // Add `@Id()` annotation if its name isn't "id" (case insensitive).
  int id = 0;

  final articleSource = ToOne<BookmarkArticleSourceEntity>();

  @Index(type: IndexType.value)
  @Unique()
  String url;

  String author,
      title,
      description,
      urlToImage,
      publishedAt,
      content,
      currentApi,
      itemsPerPage,
      currentPage;

  BookmarkArticlesEntity(
      this.author,
      this.title,
      this.content,
      this.description,
      this.publishedAt,
      this.url,
      this.urlToImage,
      this.currentApi,
      this.itemsPerPage,
      this.currentPage);
}

@Entity()
class BookmarkArticleSourceEntity {
  // Each "Entity" needs a unique integer ID property.
  // Add `@Id()` annotation if its name isn't "id" (case insensitive).
  int id = 0;

  @Index(type: IndexType.value)
  String sourceID;
  String name;

  BookmarkArticleSourceEntity(this.sourceID, this.name);
}
