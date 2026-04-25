class AppRoutes {
  static const initial = '/';
  static const application = '/application';
  static const login = '/login';
  static const signup = '/signup';
  static const projectDashboard = '/projects/dashboard';
  static const financeDashboard = '/finance/dashboard';
  static const createProject = '/projects/new';
  static const departmentMenus = '/departments/menus';
  static const subMenusScreens = '/departments/sub-menus';
  static const userDepartment = "/departments/users";
  static const usersDashboard = '/users/dashboard';
  static const createUser = '/users/new';
  static const userRoles = '/users/roles';
  static const financeInvoices = '/finance/invoices';
  static const financeTemplates = '/finance/templates';

  static const menuDepartments = "/departments/menus";

  // Base
  static const String baseUrl = 'http://192.168.1.73:8000/api/v1';

  // Auth
  static const String adminExists = '/refactor/admin/exists';
  static const String adminSignup = '/refactor/admin/signup';
  static const String loginScreen = '/refactor/login';
  static const String me = '/refactor/me';
  static const String forgotPassword = '/refactor/forgot-password';
  static const String verifyOtp = '/refactor/verify-otp';
  static const String resetPassword = '/refactor/reset-password';

  // Users
  static const String createMember = '/refactor/create-member';
  static const String getAllUsers = '/refactor/users';
  static String deleteUser(int userId) => '/refactor/users/$userId';

  //  Profile
  static String getProfile(int userId) => '/profile/$userId';
  static String updateProfile(int userId) => '/profile/$userId';
  static String personalSettings(int userId) =>
      '/profile/personal-settings/$userId';

  // Workers
  static const String createWorker = '/workers/';
  static const String fetchWorkers = '/workers/list';
  static String workerById(int id) => '/workers/$id';

  // Inventory & Materials
  static const String createMaterial = '/materials/';
  static const String getMaterials = '/materials/materials';
  static String materialById(int id) => '/materials/get_material_by_id/$id';
  static String updateMaterial(int id) => '/materials/update_materials/$id';
  static const String getAllInventory = '/materials/get_all_inventory';
  static String inventoryById(int id) => '/materials/get_inventory_by_id/$id';
  static String updateInventory(int id) => '/materials/update_inventory/$id';

  // Attendance
  static const String checkIn = '/workers/attendance/check-in';
  static const String checkInBulk = '/workers/attendance/check-in/bulk';
  static const String todayAttendance = '/workers/attendance/today';
  static const String verifyAttendance = '/workers/attendance/verify';
  static const String weekAttendance = '/workers/attendance/week';

  // Groups
  static const String getAllGroups = '/group';
  static const String createGroup = '/group/create';
  static String getGroupById(int id) => '/group/$id';
  static String assignGroupMenus(int id) => '/group/$id/menus';
  static String assignUserToGroup(int groupId, String userId) =>
      '/group$groupId/users/$userId';

  // Menus
  static const String getInvoices = '/invoices/';
  static const String createInvoices = '/invoices/create';
  static String updateInvoiceStatus(int id) => '/invoices/$id/status';
  static String updateInvoicePayment(int id) => '/invoices/$id/payment';
}
