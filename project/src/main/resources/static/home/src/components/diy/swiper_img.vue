<template>
  <b-carousel
    id="carousel"
    v-model="slide"
    :interval="4000"
    controls
    indicators
    background="#ababab"
    style="text-shadow: 1px 1px 2px #333"
    @sliding-start="onSlideStart"
    @sliding-end="onSlideEnd"
  >
    <b-carousel-slide
      v-for="(o, i) in list"
      :key="i"
    >
      <template #img>
        <a v-if="o[vm.url]" target="_blank" :href="resolveSlideUrl(o[vm.url])">
          <div class="swiper-imgs" :style="{backgroundImage: 'url(' + $fullUrl(o[vm.img]) + ')'}"></div>
        </a>
        <div v-else class="swiper-imgs" :style="{backgroundImage: 'url(' + $fullUrl(o[vm.img]) + ')'}"></div>
        <!-- <img
          class="d-block w-100"
          style="max-height:300px"
          :src="$fullUrl(fullImg(o[vm.img]))"
          :alt="o[vm.title]"
        /> -->
      </template>
    </b-carousel-slide>
  </b-carousel>
</template>

<script>
import mixin from "@/mixins/component.js";
export default {
  mixins: [mixin],
  props: {
    list: {
      type: Array,
      default: function () {
        return [];
      },
    },
    vm: {
      type: Object,
      default: function () {
        return {
          img: "img",
          title: "title",
          url: "url",
        };
      },
    },
  },
  data() {
    return {
      slide: 0,
      sliding: null,
    };
  },
  methods: {
    onSlideStart(slide) {
      this.sliding = true;
    },
    onSlideEnd(slide) {
      this.sliding = false;
    },
    resolveSlideUrl(url) {
      if (!url) return "";
      if (/^https?:\/\//i.test(url)) return url;
      let target = String(url).trim();
      if (target.indexOf("/article/details?article=") === 0) {
        target = target.replace("/article/details?article=", "/article/details?article_id=");
      }
      if (target.indexOf("/article/details?article_id=") === 0) {
        return "/#"+target;
      }
      if (target.indexOf("/") === 0 && target.indexOf("/#/") !== 0) {
        return "/#"+target;
      }
      return target;
    },
    // fullImg(img){
    //   return "/api/img/slide/"+img;
    // },
  },
};
</script>

<style scoped>
	.swiper-imgs{
		background-repeat: no-repeat;
		background-size: cover;
		height: 18.75rem;
	}
	@media (max-width: 996px) {
	    .swiper-imgs {
	        height: 12.5rem;
	    }
	}
</style>
