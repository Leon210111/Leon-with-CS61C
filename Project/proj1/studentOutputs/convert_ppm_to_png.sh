for file in GliderGuns/*.ppm;do
	convert "$file" "${file%.ppm}.png"
done
