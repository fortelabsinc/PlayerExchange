<template>
  <div class="file-upload">
    <div class="row">
      <div class="flex xs12">
        <va-card :title="$t('fileUpload.advancedMediaGallery')">
          <va-file-upload
            v-model="advancedGallery"
            type="gallery"
            file-types=".png, .jpg, .jpeg, .gif"
            dropzone
          />
        </va-card>
      </div>
      <div class="flex xs12">
        <va-card :title="$t('fileUpload.advancedUploadList')">
          <va-file-upload v-model="advancedList" dropzone />
        </va-card>
      </div>
      <div class="flex xs12">
        <va-card :title="$t('fileUpload.single')">
          <va-file-upload v-model="single" type="single" />
        </va-card>
      </div>
      <div class="flex xs12">
        <va-card :title="$t('fileUpload.mediaGallery')">
          <va-file-upload
            v-model="gallery"
            type="gallery"
            file-types=".png, .jpg, .jpeg, .gif"
          />
        </va-card>
      </div>
      <div class="flex xs12">
        <va-card :title="$t('fileUpload.uploadList')">
          <va-file-upload v-model="list" />
        </va-card>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'FileUpload',
  data() {
    return {
      advancedGallery: [],
      advancedList: [],
      single: [],
      gallery: [],
      list: [],
    }
  },
}
</script>
