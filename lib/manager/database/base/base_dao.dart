abstract class BaseDao {
  Future<void> init();

  Future<void> close();
}
