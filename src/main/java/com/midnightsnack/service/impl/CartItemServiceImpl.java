package com.midnightsnack.service.impl;

import com.midnightsnack.dao.CartItemDao;
import com.midnightsnack.dao.ProductDao;
import com.midnightsnack.entity.CartItem;
import com.midnightsnack.entity.Product;
import com.midnightsnack.service.CartItemService;
import com.midnightsnack.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 购物车服务实现类
 */
@Service
@Transactional
public class CartItemServiceImpl implements CartItemService {

    @Autowired
    private CartItemDao cartItemDao;

    @Autowired
    private ProductDao productDao;

    @Override
    public Result<CartItem> addToCart(Integer userId, Integer productId, Integer quantity) {
        // 参数验证
        if (userId == null || productId == null) {
            return Result.error("参数错误");
        }
        if (quantity == null || quantity <= 0) {
            quantity = 1;
        }

        // 检查商品是否存在
        Product product = productDao.selectById(productId);
        if (product == null) {
            return Result.error("商品不存在");
        }

        // 检查商品状态
        if (product.getStatus() == null || product.getStatus() != 1) {
            return Result.error("商品已下架");
        }

        // 检查库存
        if (product.getStock() == null || product.getStock() < quantity) {
            return Result.error("商品库存不足");
        }

        // 检查是否已在购物车中
        CartItem existingItem = cartItemDao.selectByUserIdAndProductId(userId, productId);
        if (existingItem != null) {
            // 更新数量
            int newQuantity = existingItem.getQuantity() + quantity;
            if (product.getStock() < newQuantity) {
                return Result.error("商品库存不足");
            }
            existingItem.setQuantity(newQuantity);
            cartItemDao.update(existingItem);
            return Result.success("已更新购物车商品数量", existingItem);
        } else {
            // 添加新项
            CartItem cartItem = new CartItem(userId, productId, quantity);
            cartItemDao.insert(cartItem);
            return Result.success("添加到购物车成功", cartItem);
        }
    }

    @Override
    public Result<List<CartItem>> getCartItems(Integer userId) {
        if (userId == null) {
            return Result.error("用户ID不能为空");
        }
        List<CartItem> cartItems = cartItemDao.selectByUserId(userId);
        return Result.success(cartItems);
    }

    @Override
    public Result<Void> updateQuantity(Integer cartItemId, Integer quantity, Integer userId) {
        // 参数验证
        if (cartItemId == null || quantity == null || quantity <= 0) {
            return Result.error("参数错误");
        }

        // 查询购物车项
        CartItem cartItem = cartItemDao.selectById(cartItemId);
        if (cartItem == null) {
            return Result.error("购物车项不存在");
        }

        // 验证权限
        if (!cartItem.getUserId().equals(userId)) {
            return Result.error("无权操作此购物车项");
        }

        // 检查商品库存
        Product product = productDao.selectById(cartItem.getProductId());
        if (product == null || product.getStock() < quantity) {
            return Result.error("商品库存不足");
        }

        // 更新数量
        cartItemDao.updateQuantity(cartItemId, quantity);
        return Result.success("更新成功");
    }

    @Override
    public Result<Void> removeCartItem(Integer cartItemId, Integer userId) {
        if (cartItemId == null) {
            return Result.error("参数错误");
        }

        // 查询购物车项
        CartItem cartItem = cartItemDao.selectById(cartItemId);
        if (cartItem == null) {
            return Result.error("购物车项不存在");
        }

        // 验证权限
        if (!cartItem.getUserId().equals(userId)) {
            return Result.error("无权操作此购物车项");
        }

        // 删除
        cartItemDao.deleteById(cartItemId);
        return Result.success("删除成功");
    }

    @Override
    public Result<Void> removeMultipleCartItems(List<Integer> cartItemIds, Integer userId) {
        if (cartItemIds == null || cartItemIds.isEmpty()) {
            return Result.error("参数错误");
        }

        // 验证所有购物车项都属于当前用户
        for (Integer id : cartItemIds) {
            CartItem cartItem = cartItemDao.selectById(id);
            if (cartItem != null && !cartItem.getUserId().equals(userId)) {
                return Result.error("无权操作部分购物车项");
            }
        }

        // 批量删除
        cartItemDao.deleteByIds(cartItemIds);
        return Result.success("删除成功");
    }

    @Override
    public Result<Void> clearCart(Integer userId) {
        if (userId == null) {
            return Result.error("用户ID不能为空");
        }
        cartItemDao.deleteByUserId(userId);
        return Result.success("购物车已清空");
    }

    @Override
    public Result<Integer> getCartCount(Integer userId) {
        if (userId == null) {
            return Result.error("用户ID不能为空");
        }
        int count = cartItemDao.countByUserId(userId);
        return Result.success(count);
    }
}
