-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 19-04-2024 a las 21:29:27
-- Versión del servidor: 8.0.17
-- Versión de PHP: 7.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `carrito-compra`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `encabezado_factura`
--

CREATE TABLE `encabezado_factura` (
  `id_encabezado` int(11) NOT NULL,
  `empresa` varchar(20) NOT NULL,
  `fecha` date NOT NULL,
  `nombre_cliente` varchar(50) NOT NULL,
  `nit` varchar(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `encabezado_factura`
--

INSERT INTO `encabezado_factura` (`id_encabezado`, `empresa`, `fecha`, `nombre_cliente`, `nit`) VALUES
(1, 'SupermercadoX', '2024-04-19', 'Jefferson', '120377501');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

CREATE TABLE `factura` (
  `No_factura` int(11) NOT NULL,
  `id_encabezado` int(11) NOT NULL,
  `cantidad_producto` int(11) NOT NULL,
  `precio_unitario` decimal(8,2) NOT NULL,
  `subtotal` decimal(8,2) NOT NULL,
  `sku` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `factura`
--

INSERT INTO `factura` (`No_factura`, `id_encabezado`, `cantidad_producto`, `precio_unitario`, `subtotal`, `sku`) VALUES
(1, 1, 3, '8.50', '25.50', '1234iou9'),
(2, 1, 5, '8.50', '42.50', '1234iou9');

--
-- Disparadores `factura`
--
DELIMITER $$
CREATE TRIGGER `actualizar_stock_inventario` AFTER INSERT ON `factura` FOR EACH ROW UPDATE inventario
SET stock = stock - NEW.cantidad_producto
WHERE sku = NEW.sku
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `calcular_subtotal` BEFORE INSERT ON `factura` FOR EACH ROW SET NEW.subtotal = NEW.cantidad_producto * NEW.precio_unitario
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario`
--

CREATE TABLE `inventario` (
  `id_inventario` int(11) NOT NULL,
  `stock` int(11) NOT NULL,
  `sku` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `inventario`
--

INSERT INTO `inventario` (`id_inventario`, `stock`, `sku`) VALUES
(1, 26, '1234iou9');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `sku` varchar(8) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `costo` decimal(8,2) NOT NULL,
  `precio` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`sku`, `nombre`, `descripcion`, `costo`, `precio`) VALUES
('1234iou9', 'encendedor', 'encendedor de la marca bic color rojo', '7.20', '8.50');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `encabezado_factura`
--
ALTER TABLE `encabezado_factura`
  ADD PRIMARY KEY (`id_encabezado`);

--
-- Indices de la tabla `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`No_factura`),
  ADD KEY `encabezado_factura_factura_fk` (`id_encabezado`),
  ADD KEY `producto_factura_fk` (`sku`);

--
-- Indices de la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD PRIMARY KEY (`id_inventario`),
  ADD KEY `producto_inventario_fk` (`sku`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`sku`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `encabezado_factura`
--
ALTER TABLE `encabezado_factura`
  MODIFY `id_encabezado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `factura`
--
ALTER TABLE `factura`
  MODIFY `No_factura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `inventario`
--
ALTER TABLE `inventario`
  MODIFY `id_inventario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `factura`
--
ALTER TABLE `factura`
  ADD CONSTRAINT `encabezado_factura_factura_fk` FOREIGN KEY (`id_encabezado`) REFERENCES `encabezado_factura` (`id_encabezado`),
  ADD CONSTRAINT `producto_factura_fk` FOREIGN KEY (`sku`) REFERENCES `producto` (`sku`);

--
-- Filtros para la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD CONSTRAINT `producto_inventario_fk` FOREIGN KEY (`sku`) REFERENCES `producto` (`sku`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
