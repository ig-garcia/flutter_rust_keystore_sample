#include <jni.h>

JavaVM* g_vm = NULL;

extern "C"
JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void* reserved) {
    g_vm = vm;
    return JNI_VERSION_1_6;
}

extern "C"
JNIEXPORT jlong JNICALL
Java_com_example_flutter_1keystore_1sample_MainActivity_getVM(JNIEnv* env, jobject instance) {
    return reinterpret_cast<jlong>(g_vm);
}

extern "C"
JNIEXPORT void JNICALL
Java_com_example_flutter_1keystore_1sample_MainActivity_initializeNativeLibrary(JNIEnv* env, jobject instance, jlong vm) {
// Add your initialization logic here
}
