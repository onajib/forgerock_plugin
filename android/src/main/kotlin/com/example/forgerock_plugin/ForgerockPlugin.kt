package com.example.forgerock_plugin

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.example.forgerock_plugin.utils.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.forgerock.android.auth.*
import org.forgerock.android.auth.callback.NameCallback
import org.forgerock.android.auth.callback.PasswordCallback

/** ForgerockPlugin */
class ForgerockPlugin : FlutterPlugin, MethodCallHandler {

  private lateinit var channel: MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, ANDROID_PLUGIN_CHANNEL)
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  /**
   * Method interceptor
   * Intercept called method and handles ForgeRock's SDK :
   * SDK initiation
   * Login
   * GetToken
   * logout
   */
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    Logger.set(Logger.Level.DEBUG)
    when (call.method) {
      INIT_FORGEROCK_SDK -> with(initSdk()) {
        handleSuccess(result, "$SDK_INIT_MESSAGE : $this")
      }
      FORGEROCK_LOGIN -> {
        val email = call.argument<String>(EMAIL)
        val password = call.argument<String>(PASSWORD)

        FRUser.getCurrentUser()?.let {
          handleSuccess(result, USER_AUTHENTICATED_MESSAGE)
        } ?: run {
          try {
            loginToForgeRock(result, email, password)
          } catch (e: Exception) {
            handleError(result, e, e.message)
          }
        }
      }
      FORGEROCK_TOKEN -> {
        try {
          getCurrentUserToken(result)
        } catch (e: Exception) {
          handleError(result, e, e.message)
        }
      }
      FORGEROCK_LOGOUT -> {
        try {
          logoutFromForgeRock(result)
        } catch (e: Exception) {
          handleError(result, e, e.message)
        }
      }
      PLATFORM -> handleSuccess(
        result, "Android ${android.os.Build.VERSION.RELEASE}"
      )
      else -> result.notImplemented()
    }
  }

  private fun initSdk(): Boolean {
    return try {
      Logger.set(Logger.Level.DEBUG)
      FRAuth.start(context)
      true
    } catch (e: Exception) {
      Logger.error(this.javaClass.name, e, e.message)
      false
    }
  }

  private fun loginToForgeRock(
    result: Result,
    email: String?,
    password: String?
  ) {
    FRUser.login(context, object : NodeListener<FRUser> {
      override fun onSuccess(response: FRUser) {
        handleSuccess(result, LOGIN_SUCCESSFUL_MESSAGE)
      }

      override fun onException(e: Exception) {
        Logger.error(NodeListener.TAG, e.message, e)
        handleError(
          result, e,
          LOGIN_ERROR_MESSAGE
        )
      }

      override fun onCallbackReceived(node: Node) {
        node.getCallback(NameCallback::class.java)?.setName(email)
        node.getCallback(PasswordCallback::class.java)
          ?.setPassword(password?.toCharArray())
        node.next(context, this)
      }
    })
  }

  private fun getCurrentUserToken(result: Result) {
    FRUser.getCurrentUser()?.let { user ->
      user.accessToken?.let { token ->
        handleSuccess(result, token.value)
      } ?: handleError(result, details = " GetToken Error : $ACCESS_TOKEN_NULL_MESSAGE")
    } ?: handleError(result, details = " GetToken Error : $CURRENT_USER_NULL_MESSAGE")
  }

  private fun logoutFromForgeRock(result: Result) {
    FRUser.getCurrentUser()?.logout() ?: handleError(
      result, details =
      "Logout Error : $CURRENT_USER_NULL_MESSAGE"
    )
  }

  private fun handleSuccess(result: Result, message: String) {
    Log.d(this.javaClass.name, message)
    result.success(message)
  }

  private fun handleError(result: Result, e: Exception? = null, details: String?) {
    Log.e(this.javaClass.name, e?.message, e)
    result.error(
      "",
      this.javaClass.name + e?.message,
      details ?: e?.localizedMessage ?: e?.cause ?: ""
    )
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}