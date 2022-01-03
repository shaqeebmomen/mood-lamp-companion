<template>
  <div id="app">
    <section class="hero is-primary">
      <div class="hero-body">
        <p class="title">Rav Lamp App</p>
      </div>
    </section>
    <div class="container mt-6">
      <div class="color-select">
        <div
          class="color-box"
          :style="'background-color: ' + currentColor"
        ></div>
        <div
          v-for="(color, index) in colors"
          :key="index"
          :class="'color-slide-container ' + color.toLowerCase()"
        >
          <b-field :label="color">
            <b-slider
              size="is-large"
              :disabled="
                index != 3 ? currentMode.id != 3 && currentMode.id != 1 : false
              "
              @change="valueUpdate"
              :max="255"
              :type="colorMap[color.toLowerCase()]"
              lazy
              v-model="colorData[color.toLowerCase()]"
            ></b-slider>
          </b-field>
        </div>
      </div>
      <div class="anim-select">
        <b-dropdown
          v-model="currentMode"
          aria-role="list"
          position="is-top-right"
          @change="valueUpdate"
        >
          <template #trigger>
            <b-button
              :label="currentMode.name"
              type="is-primary"
              class="is-outlined"
            />
          </template>

          <b-dropdown-item
            v-for="(mode, index) in modeEnum"
            :key="index"
            :value="mode"
            >{{ mode.name }}</b-dropdown-item
          >
        </b-dropdown>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "App",
  components: {},
  async created() {
    // Get current saved state from lamp
    const currentState = await (await fetch("/getcurrent")).json();
    this.colorData.red = currentState.r;
    this.colorData.green = currentState.g;
    this.colorData.blue = currentState.b;
    this.colorData.brightness = currentState.bright;
    this.currentMode = this.modeEnum.find((mode) => mode.id == currentState.mode);
  },
  data() {
    return {
      colors: ["Red", "Green", "Blue", "Brightness"],
      colorData: {
        red: 0,
        green: 0,
        blue: 0,
        brightness: 0,
      },
      colorMap: {
        red: "is-danger",
        green: "is-success",
        blue: "is-info",
        brightness: "is-primary",
      },
      modeEnum: [
        {
          id: 0,
          name: "White",
        },
        {
          id: 1,
          name: "Breathing",
        },
        {
          id: 2,
          name: "Rainbow",
        },
        {
          id: 3,
          name: "Solid Color",
        },
        {
          id: 4,
          name: "Off",
        },
      ],
      currentMode: {
        id: 3,
        name: "Solid Color",
      },
    };
  },
  computed: {
    currentColor() {
      return this.rgbToHex(
        this.colorData.red,
        this.colorData.green,
        this.colorData.blue
      );
    },
  },
  methods: {
    rgbToHex(r, g, b) {
      return (
        "#" +
        this.componentToHex(r) +
        this.componentToHex(g) +
        this.componentToHex(b)
      );
    },
    componentToHex(c) {
      var hex = c.toString(16);
      return hex.length == 1 ? "0" + hex : hex;
    },
    async valueUpdate() {
      this.$nextTick(async () => {
        const data = {
          r: this.colorData.red,
          g: this.colorData.green,
          b: this.colorData.blue,
          bright: this.colorData.brightness,
          mode: this.currentMode.id,
        };
        try {
          console.log("sending data", data);
          const res = await fetch("/update", {
            method: "POST",
            mode: "no-cors",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify(data),
          });
        } catch (error) {
          console.log(error);
          this.$buefy.toast.open({
            duration: 3000,
            message: "Oops, Something Went Wrong",
            type: "is-danger",
          });
        }
      });
    },
  },
};
</script>

<style>
* {
  box-sizing: border-box;
  /* border: 1px black dashed; */
}
.container {
  padding: 0% 5% 0% 5%;
  display: flex;
  flex-direction: column;
  justify-content: space-evenly;
}
.color-select {
  grid-template-rows: 1fr 1fr;
}
.title {
  grid-row: 1;
  text-align: center;
}
.color-box {
  grid-row: 1;
  min-height: 100px;
  margin: auto;
  margin-bottom: 15px;
  border: 1px black solid;
}
.color-slide-container {
  grid-row: 2;
}
.anim-select {
  /* grid-row: 2; */
  margin-top: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
