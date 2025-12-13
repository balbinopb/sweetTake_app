import 'package:get/get.dart';
import '../controllers/graph_controller.dart';

class GraphBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      GraphController(
        // TODO: replace with your actual endpoints + query params
        dailyUrl:
            'https://api.example.com/charts/daily?user_id=1&start=2025-02-01&end=2025-02-07',
        weeklyUrl:
            'https://api.example.com/charts/weekly?user_id=1&start=2025-02-01&end=2025-03-01',
        monthlyUrl:
            'https://api.example.com/charts/monthly?user_id=1&start=2025-01-01&end=2025-12-31',
      ),
    );
  }
}

// import 'package:get/get.dart';

// import '../controllers/graph_controller.dart';

// class GraphBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<GraphController>(
//       () => GraphController(),
//     );
//   }
// }

// import 'package:get/get.dart';
// import '../controllers/graph_controller.dart';

// class GraphBinding extends Bindings {
//   @override
//   void dependencies() {
//     // You can pass environment/config values here
//     Get.put(
//       GraphController(
//         dailyUrl:
//             'https://api.example.com/users/1/charts/daily?start=2025-02-01&end=2025-02-07',
//         weeklyUrl:
//             'https://api.example.com/users/1/charts/weekly?start=2025-02-01&end=2025-03-01',
//         monthlyUrl:
//             'https://api.example.com/users/1/charts/monthly?start=2025-01-01&end=2025-12-31',
//       ),
//     );
//   }
// }
