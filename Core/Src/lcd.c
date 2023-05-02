#include "lcd.h"
#include "stm32h7xx_hal.h"
#include "main.h"
#include <stdbool.h>

volatile bool active_framebuffer;
uint16_t framebuffer1[GW_LCD_WIDTH * GW_LCD_HEIGHT];
uint16_t framebuffer2[GW_LCD_WIDTH * GW_LCD_HEIGHT];
uint32_t frame_counter = 0;

// defined in Core/Src/main.c
extern DAC_HandleTypeDef hdac1;
extern DAC_HandleTypeDef hdac2;
extern LTDC_HandleTypeDef hltdc;


void HAL_LTDC_ReloadEventCallback (LTDC_HandleTypeDef *hltdc) {
  frame_counter++;
  if (active_framebuffer) {
    HAL_LTDC_SetAddress(hltdc, (uint32_t) framebuffer1, 0);
  } else {
    HAL_LTDC_SetAddress(hltdc, (uint32_t) framebuffer2, 0);
  }
}

uint32_t is_lcd_swap_pending(void)
{
  return (uint32_t) ((hltdc.Instance->SRCR) & (LTDC_SRCR_VBR | LTDC_SRCR_IMR));
}

void lcd_swap(void)
{
  HAL_LTDC_Reload(&hltdc, LTDC_RELOAD_VERTICAL_BLANKING);
  active_framebuffer = !active_framebuffer;
}

void lcd_sync(void)
{
  // copy active buffer to inactive buffer
  void *active = lcd_get_active_buffer();
  void *inactive = lcd_get_inactive_buffer();

  if (active != inactive) {
    memcpy(inactive, active, sizeof(framebuffer1));
  }
}

void* lcd_get_active_buffer(void)
{
  return active_framebuffer ? framebuffer2 : framebuffer1;
}

void* lcd_get_inactive_buffer(void)
{
  return active_framebuffer ? framebuffer1 : framebuffer2;
}

void lcd_reset_active_buffer(void)
{
  HAL_LTDC_SetAddress(&hltdc, (uint32_t) framebuffer1, 0);
  active_framebuffer = false;
}

void lcd_wait_for_vblank(void)
{
  uint32_t old_counter = frame_counter;
  while (old_counter == frame_counter) {
    __asm("nop");
  }
}
void lcd_backlight_off() {
  /*HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_5, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_6, GPIO_PIN_RESET);*/
  HAL_DAC_Stop(&hdac1, DAC_CHANNEL_1);
  HAL_DAC_Stop(&hdac1, DAC_CHANNEL_2);
  HAL_DAC_Stop(&hdac2, DAC_CHANNEL_1);
}
void lcd_backlight_on() {
  /*HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_SET);
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_5, GPIO_PIN_SET);
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_6, GPIO_PIN_SET);*/
  lcd_backlight_set(255);
}

void lcd_backlight_set(uint8_t brightness)
{
  HAL_DAC_SetValue(&hdac1, DAC_CHANNEL_1, DAC_ALIGN_8B_R, brightness);
  HAL_DAC_SetValue(&hdac1, DAC_CHANNEL_2, DAC_ALIGN_8B_R, brightness);
  HAL_DAC_SetValue(&hdac2, DAC_CHANNEL_1, DAC_ALIGN_8B_R, brightness);

  HAL_DAC_Start(&hdac1, DAC_CHANNEL_1);
  HAL_DAC_Start(&hdac1, DAC_CHANNEL_2);
  HAL_DAC_Start(&hdac2, DAC_CHANNEL_1);
}

void lcd_fill_framebuffer(uint8_t r, uint8_t g, uint8_t b) {
  uint16_t *fb = lcd_get_active_buffer();
  uint16_t color = ((r & 0x1f) << 11) | ((g & 0x3f) << 5) | (b & 0x1f);
  for (int y = 0; y < GW_LCD_HEIGHT; y++) {
      for (int x = 0; x < GW_LCD_WIDTH; x++) {
          fb[y*GW_LCD_WIDTH + x] = color;  // RGB565
      }
  }
}

void lcd_init(SPI_HandleTypeDef *spi, LTDC_HandleTypeDef *ltdc) {

  // Turn display *off* completely.
  lcd_backlight_off();

  // 3.3v power to display *SET* to disable supply.
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_1, GPIO_PIN_SET);
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_4, GPIO_PIN_RESET);


  // TURN OFF CHIP SELECT
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
  // TURN OFF PD8
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_8, GPIO_PIN_RESET);

  // Turn off CS
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
  HAL_Delay(100);


// Wake
// Enable 3.3v
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_1, GPIO_PIN_RESET);
  HAL_Delay(1);
  // Enable 1.8V
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_4, GPIO_PIN_SET);
  // also assert CS, not sure where to put this yet
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
  HAL_Delay(7);



// HAL_SPI_Transmit(spi, "\x55\x55\x55\x55\x55\x55\x55\x55\x55\x55", 10, 100);
  // Lets go, bootup sequence.
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_8, GPIO_PIN_SET);
  HAL_Delay(2);
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_8, GPIO_PIN_RESET);
  HAL_Delay(2);
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_8, GPIO_PIN_SET);

  HAL_Delay(10);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
  HAL_Delay(2);
  HAL_SPI_Transmit(spi, "\x08\x80", 2, 100);
  HAL_Delay(2);
  
  // CS
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
  // HAL_Delay(100);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
  HAL_Delay(2);
  HAL_SPI_Transmit(spi, "\x6E\x80", 2, 100);
  HAL_Delay(2);
  // CS
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
  // HAL_Delay(100);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
  HAL_Delay(2);
  HAL_SPI_Transmit(spi, "\x80\x80", 2, 100);
  
  HAL_Delay(2);
  // CS
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
  // HAL_Delay(100);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
  HAL_Delay(2);
  HAL_SPI_Transmit(spi, "\x68\x00", 2, 100);
  HAL_Delay(2);
  // CS
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
  // HAL_Delay(100);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
  HAL_Delay(2);
  HAL_SPI_Transmit(spi, "\xd0\x00", 2, 100);
  HAL_Delay(2);
  // CS
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
  // HAL_Delay(100);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
  HAL_Delay(2);
  HAL_SPI_Transmit(spi, "\x1b\x00", 2, 100);
  
  HAL_Delay(2);
  // CS
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
  // HAL_Delay(100);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
  HAL_Delay(2);
  HAL_SPI_Transmit(spi, "\xe0\x00", 2, 100);
  
  
  HAL_Delay(2);
  // CS
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
  // HAL_Delay(100);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
  HAL_Delay(2);
  HAL_SPI_Transmit(spi, "\x6a\x80", 2, 100);
  
  HAL_Delay(2);
  // CS
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
  // HAL_Delay(100);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
  HAL_Delay(2);
  HAL_SPI_Transmit(spi, "\x80\x00", 2, 100);
  HAL_Delay(2);
  // CS
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);
  // HAL_Delay(100);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
  HAL_Delay(2);
  HAL_SPI_Transmit(spi, "\x14\x80", 2, 100);
  HAL_Delay(2);
  // CS
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_SET);


  lcd_reset_active_buffer();

  lcd_backlight_on();
}

void lcd_deinit(SPI_HandleTypeDef *spi)
{
  // Chip select low.
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);
  // 3.3v power to display *SET* to disable supply.
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_1, GPIO_PIN_SET);
  // Disable 1.8v.
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_4, GPIO_PIN_RESET);
  // Pull reset line(?) low. (Flakey without this)
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_8, GPIO_PIN_RESET);
}
