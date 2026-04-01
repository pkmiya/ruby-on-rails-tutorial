// 巨大画像のアップロードを防止し、選択画像のプレビューを表示する
document.addEventListener("turbo:load", function () {
  document.addEventListener("change", function (event) {
    if (event.target.id !== "micropost_image") return;

    const image_upload = event.target;
    const image_preview = document.querySelector("#image_preview");

    if (!image_preview) return;

    if (image_upload.files.length === 0) {
      image_preview.src = "";
      image_preview.style.display = "none";
      return;
    }

    const file = image_upload.files[0];
    const size_in_megabytes = file.size / 1024 / 1024;

    if (size_in_megabytes > 5) {
      alert("Maximum file size is 5MB. Please choose a smaller file.");
      image_upload.value = "";
      image_preview.src = "";
      image_preview.style.display = "none";
      return;
    }

    image_preview.src = URL.createObjectURL(file);
    image_preview.style.display = "block";
  });
});
