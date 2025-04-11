
class StorageServiceConstants {
  static const String STORAGE_SERVICE_UUID = '71d713ef-799e-42af-9d57-9803e36b0f93';
  static const String STORAGE_CONTROL_POINT_CHARACTERISTIC_UUID = 'a84ce035-60ed-4b24-99c9-8683052aa48b';

  // Operation codes
  static const int STORAGE_CP_OP_READ_DATA = 0x01;
  static const int STORAGE_CP_OP_WRITE_DATA = 0x02;
  static const int STORAGE_CP_OP_FETCH_FIRST_BLOB = 0x03;
  static const int STORAGE_CP_OP_FETCH_NEXT_BLOB = 0x04;
  static const int STORAGE_CP_OP_FETCH_FIRST_PACKET = 0x05;
  static const int STORAGE_CP_OP_FETCH_NEXT_PACKET = 0x06;
  static const int STORAGE_CP_OP_FETCH_FIRST_PACKET_DATA = 0x07;
  static const int STORAGE_CP_OP_FETCH_NEXT_PACKET_DATA = 0x08;
  static const int STORAGE_CP_OP_GET_NUM_BLOBS = 0x09;
  static const int STORAGE_CP_OP_ERASE_MEMORY = 0x10;
  static const int STORAGE_CP_OP_GET_MEM_STATUS = 0x11;
  static const int STORAGE_CP_OP_GENERATE_FAKE_BLOB = 0x1F;
 // Máscaras de datos RTSOS
  static const int RTSOS_GYRO_DATA_MASK = 0x02;
  static const int RTSOS_ACCEL_DATA_MASK = 0x04;
  static const int RTSOS_ANGLE_DATA_MASK = 0x08;
  static const int RTSOS_USE_IMU_REFERENCE_MASK = 0x40;

static const int HS_RTSOS_BLOB_REGISTER_TYPE = 0x08;
static const int HS_1KHZ_RTSOS_BLOB_REGISTER_TYPE = 1;

  static const int STORAGE_MAX_DATA_LEN = 242;
  static const String CURRENT_TIME_SERVICE_UUID = '1805';
static const String TIMESTAMP_CHARACTERISTIC_UUID = 'd09b4c5e-dbb3-4082-aeb9-6fe0f34c9625';

}