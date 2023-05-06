#ifndef _LCD_H_
#define _LCD_H_

#include "stm32h7xx_hal.h"
#include <stdint.h>

#define GW_LCD_WIDTH 320
#define GW_LCD_HEIGHT 240

extern uint16_t framebuffer1[GW_LCD_WIDTH * GW_LCD_HEIGHT];
extern uint16_t framebuffer2[GW_LCD_WIDTH * GW_LCD_HEIGHT];

void lcd_init(SPI_HandleTypeDef *spi, LTDC_HandleTypeDef *ltdc);
void lcd_deinit(SPI_HandleTypeDef *spi);
void lcd_backlight_on();
void lcd_backlight_off();
void lcd_backlight_set(uint8_t brightness);


void lcd_swap(void);
void lcd_sync(void);
void* lcd_get_active_buffer(void);
void* lcd_get_inactive_buffer(void);
void lcd_wait_for_vblank(void);
uint32_t is_lcd_swap_pending(void);

// To be used by fault handlers
void lcd_reset_active_buffer(void);
#endif
