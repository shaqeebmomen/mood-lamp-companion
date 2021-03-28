import Vue from 'vue'
import App from './App.vue'

import {Dropdown, Field, Slider, Button, Toast} from 'buefy'

import 'buefy/dist/buefy.min.css'

Vue.config.productionTip = false

Vue.use(Dropdown);
Vue.use(Field);
Vue.use(Slider);
Vue.use(Button);
Vue.use(Toast);


new Vue({
  render: h => h(App),
}).$mount('#app')
