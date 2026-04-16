import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/commons/widgets/custom_button.dart';
import 'package:graville_operations/core/routes/names.dart';
import 'package:graville_operations/screens/store/inventory/controller.dart';
import 'package:graville_operations/screens/store/widgets/material_tile.dart';

class InventoryScreen extends GetView<InventoryScreenController> {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Store"),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Materials",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                if (controller.state.isLoadingMaterials.value)
                  const Center(child: CircularProgressIndicator())
                else if (controller.state.materialsErrorMessage.value.isNotEmpty)
                  Column(
                    children: [
                      Text(controller.state.materialsErrorMessage.value),
                      ElevatedButton(
                        onPressed: controller.getStoreMaterials,
                        child: const Text("Retry"),
                      ),
                    ],
                  )
                else if (controller.state.materials.isEmpty)
                  const Center(child: Text("No materials found."))
                else
                  ...controller.state.materials.map(
                    (mat) => MaterialTile(
                      icon: Icons.store,
                      name: mat.materialName,
                      quantity: mat.quantity,
                      unit: mat.unitSymbol,
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Tools",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                if (controller
                    .state.isLoadingTools.value) // ← uses isLoadingTools now
                  const Center(child: CircularProgressIndicator())
                else if (controller.state.toolsErrorMessage.value.isNotEmpty)
                  Column(
                    children: [
                      Text(controller.state.toolsErrorMessage.value),
                      ElevatedButton(
                        onPressed: controller.getStoreTools,
                        child: const Text("Retry"),
                      ),
                    ],
                  )
                else if (controller.state.tools.isEmpty)
                  const Center(child: Text("No tools found."))
                else
                  ...controller.state.tools.map(
                    (tool) => MaterialTile(
                      icon: Icons.construction,
                      name: tool.tool,
                      quantity: tool.quantity,
                      unit: "Units",
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: "Add Hired Tool",
                      onPressed: () => Get.toNamed(AppRoutes.addHiredTool),
                      buttonStyle: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
