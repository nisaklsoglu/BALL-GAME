# BALL-GAME
FPGA üzerindeki button ve switchlerden giriş alarak VGA ekran
üzerinde çıktı veren bir oyun

Projemizde FPGA üzerindeki button ve switchlerden giriş alarak
VGA ekran üzerinde çıktı veren bir oyun tasarladık.Oyunumuzun
adı Dünyanın En Zor Oyunu.Oyunumuzun temelinde hareket
ettirebildiğimiz bir kare var.Bu karenin amacı hedefe ulaşmak ve
diğer bölüme atlamak.Bu esnada hareketli toplara değdiğinde
bölüm tekrar başlar ve kare haritada belirtilen siyah alanların
dışına çıkamaz.

**top.v:** Sistemin giriş ve çıkışlarını yöneten bu modülde
vga_controller,pixel_gen,debounce modüllerini çağırıyoruz.Yani
tasarladığımız modülleri bir araya getirdik ve bunlar arasındaki
bağlantıyı sağladık.Bu sayede oyuncu için sistemi kullanılır hale
getirdik.

**vga_controller[1]:** Oyunun grafiksel çıktıların ekranda
görüntülenmesini sağlamak için kullandık. Kontrolör, oyun
ekranındaki piksellerin doğru konum ve renkte çizilmesinden
sorumlu. Vga_controller sayesinde ekrandaki renkler doğru
konumda görüntülenebilir. Bu sayede oyun monitörde veya
benzeri görüntülenme cihazlarında oynanabilir hale geldi.

**debounce.v[2]:** Butonlara basıldığındaki hatalı girişlerin önüne
geçer.Doğru giriş algılanmasını sağlar.Yanlış tetiklenmelerin
önlenmesinde görevli modüldür.

**map.v:** Oyun haritasındaki verileri işlemek ve bunları doğru bir
şekilde ekrana bastırmak için tasarladık.Harita verileri memory
dosyasından okunur. Modül her pikseli için renk bilgisi üretir.Bu
sayede duvarlarımızın görsellerini oluşturmuş oluruz. Memory
dosyasını oluşturmak için aşağıdaki görseli kullanarak haritamızı
çizdikten sonra .mem kodlu dosyaya 0’lar duvar 1’ler boşluk
olacak şekilde girdik.

**pixel_gen.v:** Oyunun grafiksel çıktılarını oluşturmak ve VGA
ekranında doğru renk ve piksel düzeniyle göstermek için
kullanılmıştır.Oyundaki nesnelerin yani
oyuncu,engeller(toplar),duvarların durumu ve konumlarını
belirleyen modülür.Oyuncunun duvarların içinden geçmesini
engelleyen kodları da içerir bunlar sayesinde oyuncunun hareket
edebileceği alanları kısıtlamış olduruz.Ball_rom modülünden
alınan top(engel) bilgileri ile bu topların hareket doğrultusuna göre
görsel çıktı verilmesini de bu modülde sağladık.Engellere temas
halinde bölüme baştan başlanmasını da bu modülde
sağladık.Pixel_gen1 modülünün bitti çıktısına göre pixel_gen2
modülü çalışır ve oyun 2. Bölüme geçmiş olur.

**ball_rom.v:** Oyuncu engellere temas ettiğinde bölümün başına
dönmesine neden olan topları içeren modüldür.

**sprite.v:** Map modülünden aldığı harita bilgilerini kullanarak her
pikselin renk kodunu tutan modüldür.

**Kaynakça**

[1] https://github.com/FPGADude/Digital-
Design/blob/main/FPGA%20Projects/VGA%20Projects/Pong%20pt2/vga_c
ontroller.v
[2] https://github.com/FPGADude/Digital-
Design/blob/main/FPGA%20Projects/VGA%20Projects/Pong%20pt1/debo
unce.v
