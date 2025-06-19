// Example component using file upload
<script setup>
import { ref, props } from 'vue';
import { projectService } from '@/services/projectService';

const prop = props({
	projectId: {
		type: string
	}
});

const uploadStatus = ref('');
const loading = ref(false);

const handleFileUpload = async (event) => {
  loading.value = true;
  uploadStatus.value = '';
  
  try {
    const file = event.target.files[0];
    const documentData = {
      title: file.name, // or you can have a separate input for title
      description: 'Document description', // or you can have a separate input for description
      file: file
    };

    const response = await projectService.uploadDocument(prop.projectId, documentData);
    uploadStatus.value = 'File uploaded successfully!';
    // Optionally refresh document list or emit event to parent
  } catch (error) {
    console.error('Upload failed:', error);
    uploadStatus.value = 'Failed to upload file';
  } finally {
    loading.value = false;
  }
};
</script>

<template>
  <div class="space-y-4">
    <div class="flex items-center gap-4">
		<form>
			<input
				type="file"
				@change="(e) => handleFileUpload(e, projectId)"
				:disabled="loading"
				class="block w-full text-sm text-slate-500
				file:mr-4 file:py-2 file:px-4
				file:rounded-full file:border-0
				file:text-sm file:font-semibold
				file:bg-violet-50 file:text-violet-700
				hover:file:bg-violet-100"
			/>
			<input
				type="text"
				
			/>
			<button
				@submit="handleFileUpload"
			>Upload</button>
		</form>
		<div v-if="loading" class="text-gray-500">
			Uploading...
		</div>
    </div>
    
    <div v-if="uploadStatus" 
      :class="{'text-green-600': uploadStatus.includes('success'), 
               'text-red-600': uploadStatus.includes('failed')}"
      class="text-sm">
      {{ uploadStatus }}
    </div>
  </div>
</template>