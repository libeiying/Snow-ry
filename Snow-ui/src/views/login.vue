<template>
  <div class="auth-page login">
    <section class="auth-scene" aria-hidden="true" @click="handleSceneClick">
      <div class="snow-layer" aria-hidden="true">
        <span
          v-for="flake in snowflakes"
          :key="flake.id"
          class="snowflake"
          :style="flake.style"
        />
      </div>
      <div class="scene-mask"></div>
      <div class="scene-text">
        <p class="scene-tag">雪程搭子</p>
        <h2 class="scene-title">
          <span>连接每一段</span>
          <span>治愈雪旅</span>
        </h2>
      </div>
    </section>
    <section class="auth-panel">
      <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="auth-form">
        <h3 class="title">{{ title }}</h3>
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            type="text"
            auto-complete="off"
            placeholder="账号"
          >
            <svg-icon slot="prefix" icon-class="user" class="el-input__icon input-icon" />
          </el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            auto-complete="off"
            placeholder="密码"
            @keyup.enter.native="handleLogin"
          >
            <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
          </el-input>
        </el-form-item>
        <el-form-item class="captcha-item" prop="code" v-if="captchaEnabled">
          <el-input
            v-model="loginForm.code"
            auto-complete="off"
            placeholder="验证码"
            @keyup.enter.native="handleLogin"
          >
            <svg-icon slot="prefix" icon-class="validCode" class="el-input__icon input-icon" />
          </el-input>
          <div class="login-code">
            <img :src="codeUrl" @click="getCode" class="login-code-img"/>
          </div>
        </el-form-item>
        <el-checkbox v-model="loginForm.rememberMe" class="remember-check">记住密码</el-checkbox>
        <el-form-item class="submit-item">
          <el-button
            :loading="loading"
            size="medium"
            type="primary"
            class="auth-submit-btn"
            @click.native.prevent="handleLogin"
          >
            <span v-if="!loading">登 录</span>
            <span v-else>登 录 中...</span>
          </el-button>
          <div class="auth-link-row" v-if="register">
            <router-link class="link-type" :to="'/register'">立即注册</router-link>
          </div>
        </el-form-item>
      </el-form>
    </section>
    <div class="el-login-footer">
      <span>Copyright © 2026 雪程搭子 · Snow Journey Partner. 保留所有权利。</span>
    </div>
  </div>
</template>

<script>
import { getCodeImg } from "@/api/login"
import Cookies from "js-cookie"
import { encrypt, decrypt } from '@/utils/jsencrypt'

export default {
  name: "Login",
  data() {
    return {
      title: process.env.VUE_APP_TITLE,
      codeUrl: "",
      loginForm: {
        username: "admin",
        password: "admin123",
        rememberMe: false,
        code: "",
        uuid: ""
      },
      loginRules: {
        username: [
          { required: true, trigger: "blur", message: "请输入您的账号" }
        ],
        password: [
          { required: true, trigger: "blur", message: "请输入您的密码" }
        ],
        code: [{ required: true, trigger: "change", message: "请输入验证码" }]
      },
      loading: false,
      // 验证码开关
      captchaEnabled: true,
      // 注册开关
      register: true,
      redirect: undefined,
      snowflakes: [],
      sceneClickCount: 0
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  created() {
    this.getCode()
    this.getCookie()
    this.snowflakes = this.createSnowflakes(90)
  },
  methods: {
    randomRange(min, max) {
      return Math.random() * (max - min) + min
    },
    createSnowflakes(total) {
      return Array.from({ length: total }, (_, index) => {
        const size = this.randomRange(1.2, 6.4)
        return {
          id: `flake-${index}`,
          style: {
            left: `${this.randomRange(0, 100)}%`,
            top: `${this.randomRange(-100, 100)}vh`,
            width: `${size}px`,
            height: `${size}px`,
            opacity: this.randomRange(0.3, 0.95).toFixed(2),
            animationDuration: `${this.randomRange(9, 24).toFixed(2)}s`,
            animationDelay: `${this.randomRange(-22, 0).toFixed(2)}s`,
            "--snow-drift": `${this.randomRange(-70, 80).toFixed(2)}px`
          }
        }
      })
    },
    handleSceneClick() {
      this.sceneClickCount += 1
      const level = Math.min(this.sceneClickCount, 12)
      this.snowflakes = this.snowflakes.map((flake, index) => {
        const baseDuration = Number.parseFloat(flake.style.animationDuration)
        const nextDuration = Math.max(4.8, baseDuration - 0.22)
        const size = Number.parseFloat(flake.style.width)
        const drift = Number.parseFloat(flake.style["--snow-drift"])
        const extraOpacity = Math.min(0.98, Number.parseFloat(flake.style.opacity) + 0.02)
        if ((index + level) % 3 !== 0) {
          return {
            ...flake,
            style: {
              ...flake.style,
              animationDuration: `${nextDuration.toFixed(2)}s`,
              opacity: extraOpacity.toFixed(2)
            }
          }
        }
        return {
          ...flake,
          style: {
            ...flake.style,
            width: `${Math.min(size + 0.22, 8.6).toFixed(2)}px`,
            height: `${Math.min(size + 0.22, 8.6).toFixed(2)}px`,
            animationDuration: `${nextDuration.toFixed(2)}s`,
            "--snow-drift": `${(drift * 1.05).toFixed(2)}px`,
            opacity: extraOpacity.toFixed(2)
          }
        }
      })
    },
    getCode() {
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
        if (this.captchaEnabled) {
          this.codeUrl = "data:image/gif;base64," + res.img
          this.loginForm.uuid = res.uuid
        }
      })
    },
    getCookie() {
      const username = Cookies.get("username")
      const password = Cookies.get("password")
      const rememberMe = Cookies.get('rememberMe')
      this.loginForm = {
        username: username === undefined ? this.loginForm.username : username,
        password: password === undefined ? this.loginForm.password : decrypt(password),
        rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
      }
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          if (this.loginForm.rememberMe) {
            Cookies.set("username", this.loginForm.username, { expires: 30 })
            Cookies.set("password", encrypt(this.loginForm.password), { expires: 30 })
            Cookies.set('rememberMe', this.loginForm.rememberMe, { expires: 30 })
          } else {
            Cookies.remove("username")
            Cookies.remove("password")
            Cookies.remove('rememberMe')
          }
          this.$store.dispatch("Login", this.loginForm).then(() => {
            this.$router.push({ path: this.redirect || "/" }).catch(()=>{})
          }).catch(() => {
            this.loading = false
            if (this.captchaEnabled) {
              this.getCode()
            }
          })
        }
      })
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss">
.auth-page {
  position: relative;
  display: flex;
  min-height: 100vh;
  width: 100%;
  justify-content: flex-end;
  align-items: stretch;
  background: #dbe7f5;
  overflow: hidden;
}

.auth-scene {
  position: absolute;
  inset: 0;
  cursor: pointer;
  background-image:
    linear-gradient(155deg, rgba(16, 48, 90, 0.35), rgba(16, 48, 90, 0.05) 45%, rgba(7, 23, 44, 0.42)),
    url("https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=2200&q=80");
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  transform: scale(1.02);
}

.scene-mask {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(circle at 82% 22%, rgba(255, 255, 255, 0.26), transparent 42%),
    radial-gradient(circle at 18% 74%, rgba(192, 226, 255, 0.24), transparent 50%);
}

.snow-layer {
  position: absolute;
  inset: 0;
  pointer-events: none;
  overflow: hidden;
}

.snowflake {
  position: absolute;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.95);
  filter: drop-shadow(0 0 8px rgba(255, 255, 255, 0.45));
  animation: snow-fall linear infinite;
  will-change: transform;
}

@keyframes snow-fall {
  from {
    transform: translate3d(0, -14vh, 0);
  }
  to {
    transform: translate3d(var(--snow-drift), 120vh, 0);
  }
}

.scene-text {
  position: absolute;
  left: clamp(24px, 6vw, 120px);
  bottom: clamp(44px, 13vh, 120px);
  z-index: 2;
  color: #f4fbff;
  max-width: 620px;

  h2 {
    margin: 8px 0 0;
    font-size: clamp(32px, 3vw, 50px);
    line-height: 1.2;
    text-shadow: 0 10px 28px rgba(12, 37, 74, 0.35);
  }
}

.scene-tag {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin: 0;
  padding: 8px 16px;
  border-radius: 999px;
  color: #e7f5ff;
  font-size: 13px;
  letter-spacing: 0.2em;
  background: rgba(12, 55, 104, 0.36);
  backdrop-filter: blur(4px);
}

.scene-title {
  display: inline-flex;
  flex-direction: column;
  gap: clamp(2px, 0.5vw, 8px);
  transition: transform 0.45s ease, text-shadow 0.45s ease;
  animation: scene-title-breathe 5.6s ease-in-out infinite;

  span {
    display: inline-block;
    transition: transform 0.45s ease, letter-spacing 0.35s ease, color 0.35s ease, opacity 0.35s ease;
    transform-origin: left center;
  }
}

.scene-title span:first-child {
  animation: scene-title-float-a 6.2s ease-in-out infinite;
}

.scene-title span:last-child {
  animation: scene-title-float-b 7.1s ease-in-out infinite;
}

.scene-text:hover .scene-title {
  transform: translateY(-3px);
  text-shadow: 0 14px 30px rgba(7, 27, 58, 0.42);
  animation-play-state: paused;
}

.scene-text:hover .scene-title span:first-child {
  transform: translateX(clamp(4px, 1vw, 12px));
  letter-spacing: 0.06em;
  color: #f7fbff;
  opacity: 1;
  animation-play-state: paused;
}

.scene-text:hover .scene-title span:last-child {
  transform: translateX(clamp(10px, 1.8vw, 22px)) scale(1.02);
  letter-spacing: 0.08em;
  color: #ffffff;
  opacity: 1;
  animation-play-state: paused;
}

@keyframes scene-title-breathe {
  0%, 100% {
    transform: translateY(0);
    text-shadow: 0 10px 28px rgba(12, 37, 74, 0.35);
  }
  50% {
    transform: translateY(-2px);
    text-shadow: 0 14px 30px rgba(10, 31, 63, 0.42);
  }
}

@keyframes scene-title-float-a {
  0%, 100% {
    transform: translateX(0);
    opacity: 0.96;
  }
  50% {
    transform: translateX(clamp(2px, 0.6vw, 8px));
    opacity: 1;
  }
}

@keyframes scene-title-float-b {
  0%, 100% {
    transform: translateX(0);
    opacity: 0.95;
  }
  50% {
    transform: translateX(clamp(4px, 1vw, 14px));
    opacity: 1;
  }
}

.auth-panel {
  position: relative;
  z-index: 2;
  width: min(520px, 42vw);
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  padding: 64px clamp(22px, 4vw, 70px) 84px;
}

.auth-form {
  width: min(420px, 100%);
  padding: 40px 34px 22px;
  border-radius: 24px;
  background: rgba(245, 249, 255, 0.88);
  border: 1px solid rgba(255, 255, 255, 0.72);
  box-shadow: 0 30px 65px rgba(26, 73, 119, 0.24);
  backdrop-filter: blur(10px);

  .el-input {
    input {
      height: 46px;
      border-radius: 12px;
      border: 1px solid rgba(127, 184, 236, 0.48);
      background: rgba(247, 252, 255, 0.88);
      color: #2c4a66;
    }
  }

  .input-icon {
    width: 16px;
    height: 44px;
    margin-left: 4px;
    color: #6aa6d8;
  }
}

.title {
  margin: 0 0 28px;
  text-align: center;
  color: #23517d;
  font-size: 30px;
  font-weight: 600;
  letter-spacing: 0.1em;
}

.captcha-item {
  .el-form-item__content {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: nowrap;
  }

  .el-input {
    flex: 1 1 auto;
    min-width: 0;
  }
}

.login-code {
  flex: 0 0 128px;
  height: 46px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 10px 26px rgba(53, 120, 184, 0.2);

  img {
    display: block;
    width: 100%;
    height: 100%;
    cursor: pointer;
  }
}

.remember-check {
  margin: 4px 0 22px;
  color: #4f7498;
}

.submit-item {
  margin-bottom: 8px;
}

.auth-submit-btn {
  width: 100%;
  height: 48px;
  border: none;
  border-radius: 14px;
  font-size: 16px;
  letter-spacing: 0.2em;
  background: linear-gradient(120deg, #2d8ef5 0%, #64b5ff 100%);
  box-shadow: 0 14px 30px rgba(34, 122, 207, 0.34);
}

.auth-link-row {
  margin-top: 14px;
  text-align: right;
}

.link-type {
  color: #2f80d4;
}

.el-login-footer {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 10px;
  text-align: center;
  color: rgba(255, 255, 255, 0.9);
  font-size: 12px;
  letter-spacing: 0.08em;
  text-shadow: 0 2px 10px rgba(17, 54, 99, 0.38);
}

@media (max-width: 1200px) {
  .scene-text h2 {
    font-size: 34px;
  }

  .auth-panel {
    width: min(500px, 48vw);
  }
}

@media (max-width: 992px) {
  .auth-page {
    justify-content: center;
  }

  .auth-scene {
    transform: scale(1.08);
  }

  .scene-text {
    left: 20px;
    bottom: 20px;
    h2 {
      font-size: 28px;
    }
  }

  .auth-panel {
    width: 100%;
    min-height: 100vh;
    padding: 20px 16px 60px;
    justify-content: center;
  }

  .el-login-footer {
    bottom: 4px;
    color: rgba(233, 243, 255, 0.92);
    text-shadow: 0 2px 10px rgba(9, 27, 52, 0.45);
  }
}

.login-code-img {
  width: 100%;
  height: 100%;
}
</style>
