package com.midnightsnack.service;

import com.midnightsnack.entity.CartItem;
import com.midnightsnack.util.Result;

import java.util.List;

/**
 * 购物车服务接口
 */
public interface CartItemService {

    /**
     * 添加商品到购物车
     * @param userId 用户ID
     * @param productId 商品ID
     * @param quantity 数量
     * @return 操作结果
     */
    Result<CartItem> addToCart(Integer userId, Integer productId, Integer quantity);

    /**
     * 获取用户的购物车列表
     * @param userId 用户ID
     * @return 购物车项列表
     */
    Result<List<CartItem>> getCartItems(Integer userId);

    /**
     * 更新购物车商品数量
     * @param cartItemId 购物车项ID
     * @param quantity 新数量
     * @param userId 用户ID（用于验证权限）
     * @return 操作结果
     */
    Result<Void> updateQuantity(Integer cartItemId, Integer quantity, Integer userId);

    /**
     * 删除购物车项
     * @param cartItemId 购物车项ID
     * @param userId 用户ID（用于验证权限）
     * @return 操作结果
     */
    Result<Void> removeCartItem(Integer cartItemId, Integer userId);

    /**
     * 批量删除购物车项
     * @param cartItemIds 购物车项ID列表
     * @param userId 用户ID（用于验证权限）
     * @return 操作结果
     */
    Result<Void> removeMultipleCartItems(List<Integer> cartItemIds, Integer userId);

    /**
     * 清空用户购物车
     * @param userId 用户ID
     * @return 操作结果
     */
    Result<Void> clearCart(Integer userId);

    /**
     * 获取购物车商品总数
     * @param userId 用户ID
     * @return 商品总数
     */
    Result<Integer> getCartCount(Integer userId);
}
